module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits for 4 states
localparam IDLE = 2'b00, // initial state, nothing recognized yet
          SEEN_1 = 2'b01, // seen '11' so far
          SEEN_11 = 2'b10, // seen '110' so far
          SEEN_1101 = 2'b11; // seen the full sequence '1101'

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEEN_1;
                end
            end
            SEEN_1: begin
                if (data) begin
                    state <= SEEN_11;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN_11: begin
                if (data) begin
                    state <= IDLE; // restart since next expected is '01'
                end else begin
                    state <= SEEN_1101;
                end
            end
            SEEN_1101: begin
                start_shifting <= 1; // Set start_shifting to 1 forever after sequence is found
            end
        endcase
    end
end

endmodule