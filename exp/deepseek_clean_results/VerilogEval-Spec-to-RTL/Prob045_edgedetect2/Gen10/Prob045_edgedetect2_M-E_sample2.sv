module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State encoding for each bit
    localparam STABLE_0 = 2'b00;
    localparam STABLE_1 = 2'b01;
    localparam EDGE_DETECTED = 2'b10;

    reg [1:0] state [7:0];  // State for each bit

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            case (state[i])
                STABLE_0: begin
                    anyedge[i] <= 0;
                    if (in[i]) state[i] <= EDGE_DETECTED;
                    else state[i] <= STABLE_0;
                end
                STABLE_1: begin
                    anyedge[i] <= 0;
                    if (!in[i]) state[i] <= EDGE_DETECTED;
                    else state[i] <= STABLE_1;
                end
                EDGE_DETECTED: begin
                    anyedge[i] <= 1;
                    if (in[i]) state[i] <= STABLE_1;
                    else state[i] <= STABLE_0;
                end
                default: state[i] <= STABLE_0;
            endcase
        end
    end

    // Initialize all bits to STABLE_0
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            state[i] = STABLE_0;
            anyedge[i] = 0;
        end
    end

endmodule