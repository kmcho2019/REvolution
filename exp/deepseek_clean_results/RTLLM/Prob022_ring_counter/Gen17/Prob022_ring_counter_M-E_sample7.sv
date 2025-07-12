module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Define states as one-hot encoded values
localparam [7:0] STATE_0 = 8'b00000001;
localparam [7:0] STATE_1 = 8'b00000010;
localparam [7:0] STATE_2 = 8'b00000100;
localparam [7:0] STATE_3 = 8'b00001000;
localparam [7:0] STATE_4 = 8'b00010000;
localparam [7:0] STATE_5 = 8'b00100000;
localparam [7:0] STATE_6 = 8'b01000000;
localparam [7:0] STATE_7 = 8'b10000000;

// State register
reg [7:0] current_state;

// Next state and output logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= STATE_0;
    end
    else begin
        case (current_state)
            STATE_0: current_state <= STATE_1;
            STATE_1: current_state <= STATE_2;
            STATE_2: current_state <= STATE_3;
            STATE_3: current_state <= STATE_4;
            STATE_4: current_state <= STATE_5;
            STATE_5: current_state <= STATE_6;
            STATE_6: current_state <= STATE_7;
            STATE_7: current_state <= STATE_0;
            default: current_state <= STATE_0;
        endcase
    end
end

// Output assignment
always @(*) begin
    out = current_state;
end

endmodule