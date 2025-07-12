module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam CALC  = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] shifted_bin;
    reg [31:0] acc;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 16) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            shifted_bin <= 32'b0;
            acc <= 32'b0;
            count <= 5'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    shifted_bin <= 32'b0;
                    acc <= 32'b0;
                    count <= 5'b0;
                end
                LOAD: begin
                    areg <= ain;
                    shifted_bin <= {16'b0, bin};
                    acc <= 32'b0;
                    count <= 5'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_bin;
                    end
                    shifted_bin <= shifted_bin << 1;
                    count <= count + 1;
                end
                DONE: begin
                    // Maintain values
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule