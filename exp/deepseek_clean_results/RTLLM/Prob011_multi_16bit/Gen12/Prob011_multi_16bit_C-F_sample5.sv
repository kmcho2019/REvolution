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
    reg done_r;
    wire [15:0] remaining_bits;

    // Pre-compute all possible shifted versions
    wire [31:0] shifted [0:15];
    generate
        genvar i;
        for (i=0; i<16; i=i+1) begin : shift_gen
            assign shifted[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Early termination detection
    assign remaining_bits = areg >> count;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
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
            LOAD: next_state = (remaining_bits == 0) ? DONE : CALC;
            CALC: begin
                if (count == 15 || remaining_bits == 0)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
            done_r <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                    done_r <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                    done_r <= 1'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted[count];
                    end
                    count <= count + 1;
                    done_r <= 1'b0;
                end
                DONE: begin
                    done_r <= 1'b1;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = done_r;

endmodule