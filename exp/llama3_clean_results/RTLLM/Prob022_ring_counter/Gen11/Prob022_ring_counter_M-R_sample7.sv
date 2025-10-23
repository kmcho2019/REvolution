module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        out <= {out[6:0], out[7]}; // Shift right and feed MSB back into LSB
    end
end

// Alternatively, we can use a different structure for the ring counter
// by utilizing a shift register and a conditional operator.

module ring_counter_alternative(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        reg [7:0] temp;
        temp = out >> 1; // Shift right
        temp[0] = out[7]; // Feed MSB back into LSB
        out <= temp; // Update the output
    end
end

endmodule

// Another approach could utilize a different state machine structure.
module ring_counter_fsm(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // 3-bit state variable

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
        state <= 0; // Reset the state variable
    end else begin
        case (state)
            3'b000: begin // State 0
                out <= 8'b0000_0001;
                state <= 3'b001;
            end
            3'b001: begin // State 1
                out <= 8'b0000_0010;
                state <= 3'b010;
            end
            3'b010: begin // State 2
                out <= 8'b0000_0100;
                state <= 3'b011;
            end
            3'b011: begin // State 3
                out <= 8'b0000_1000;
                state <= 3'b100;
            end
            3'b100: begin // State 4
                out <= 8'b0001_0000;
                state <= 3'b101;
            end
            3'b101: begin // State 5
                out <= 8'b0010_0000;
                state <= 3'b110;
            end
            3'b110: begin // State 6
                out <= 8'b0100_0000;
                state <= 3'b111;
            end
            3'b111: begin // State 7
                out <= 8'b1000_0000;
                state <= 3'b000; // Wrap around to state 0
            end
            default: begin
                out <= 8'b0000_0001; // Default to initial state
                state <= 3'b000;
            end
        endcase
    end
end

endmodule

// Using the assign keyword
module ring_counter_assign(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_state;

assign next_state = reset? 8'b0000_0001 : {out[6:0], out[7]};

always @(posedge clk) begin
    out <= next_state;
end

endmodule