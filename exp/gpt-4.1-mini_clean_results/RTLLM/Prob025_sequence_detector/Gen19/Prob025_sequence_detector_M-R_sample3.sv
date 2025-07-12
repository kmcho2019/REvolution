module sequence_detector (
    input  wire clk,
    input  wire rst_n,          // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // FSM state encoding
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next-state logic as continuous assignment
    assign next_state = (state == IDLE) ? (data_in ? S1 : IDLE) :
                        (state == S1)   ? (data_in ? S1 : S2)   :
                        (state == S2)   ? (data_in ? S1 : S3)   :
                        (state == S3)   ? (data_in ? S4 : IDLE) :
                        (state == S4)   ? (data_in ? S1 : IDLE) :
                        IDLE;

    // Sequential block for state and output
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule