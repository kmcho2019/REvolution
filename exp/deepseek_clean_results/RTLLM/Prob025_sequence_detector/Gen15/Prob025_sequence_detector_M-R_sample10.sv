module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state;  // Tracks pattern progress: [0]=got 1, [1]=got 10, [2]=got 100

// Continuous assignment for next state logic
wire got_1 = data_in;
wire got_10 = state[0] & ~data_in;
wire got_100 = state[1] & ~data_in;
wire got_1001 = state[2] & data_in;

// State update and detection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b0;
        sequence_detected <= 1'b0;
    end else begin
        state <= {got_100, got_10, got_1};
        sequence_detected <= got_1001;
    end
end

endmodule