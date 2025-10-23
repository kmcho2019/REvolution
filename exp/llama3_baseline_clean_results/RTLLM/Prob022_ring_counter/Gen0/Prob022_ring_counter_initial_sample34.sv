module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Define the initial state of the ring counter
localparam INITIAL_STATE = 8'b0000_0001;

// Define the states of the ring counter
localparam STATE_0 = 8'b0000_0001;
localparam STATE_1 = 8'b0000_0010;
localparam STATE_2 = 8'b0000_0100;
localparam STATE_3 = 8'b0000_1000;
localparam STATE_4 = 8'b0001_0000;
localparam STATE_5 = 8'b0010_0000;
localparam STATE_6 = 8'b0100_0000;
localparam STATE_7 = 8'b1000_0000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= INITIAL_STATE;
    end else begin
        case (out)
            STATE_0: out <= STATE_1;
            STATE_1: out <= STATE_2;
            STATE_2: out <= STATE_3;
            STATE_3: out <= STATE_4;
            STATE_4: out <= STATE_5;
            STATE_5: out <= STATE_6;
            STATE_6: out <= STATE_7;
            STATE_7: out <= STATE_0;
            default: out <= INITIAL_STATE;
        endcase
    end
end

endmodule