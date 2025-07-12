module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam LOAD  = 4'b0010;
    localparam CALC  = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state;
    reg [3:0] next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    wire [31:0] shifted_b [0:15];
    wire clk_gated;
    wire clk_en;

    // Clock gating
    assign clk_en = (state != IDLE) || start;
    assign clk_gated = clk & clk_en;

    // Pre-compute all shifted versions
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = {16'b0, breg} << i;
        end
    endgenerate

    // State transition logic
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 4'b1111) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    // Use bitmask to select partial product
                    acc <= acc | (shifted_b[count] & {32{areg[count]}});
                    count <= count + 1;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule