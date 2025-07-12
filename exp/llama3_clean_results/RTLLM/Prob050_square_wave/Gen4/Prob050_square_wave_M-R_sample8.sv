module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle wave_out
        count <= 8'd0; // Reset count
    end else begin
        count <= count + 8'd1; // Increment count
    end
end

// Alternative implementation using a state machine (commented out)
// enum {IDLE, COUNTING} state, next_state;
// always @(posedge clk) begin
//     case (state)
//         IDLE: begin
//             if (count == (freq - 1)) begin
//                 wave_out <= ~wave_out; // Toggle wave_out
//                 count <= 8'd0; // Reset count
//                 next_state = COUNTING;
//             end else begin
//                 count <= count + 8'd1; // Increment count
//                 next_state = IDLE;
//             end
//         end
//         COUNTING: begin
//             if (count == (freq - 1)) begin
//                 wave_out <= ~wave_out; // Toggle wave_out
//                 count <= 8'd0; // Reset count
//                 next_state = IDLE;
//             end else begin
//                 count <= count + 8'd1; // Increment count
//                 next_state = COUNTING;
//             end
//         end
//     endcase
//     state <= next_state;
// end

// Explicit initialization of wave_out
initial begin
    wave_out = 1'b0; // Initialize wave_out to a known state
end

endmodule