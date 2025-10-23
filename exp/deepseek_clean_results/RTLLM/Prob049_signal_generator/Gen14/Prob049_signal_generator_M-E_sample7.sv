module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire [4:0] next_inc = wave + 1'b1;
wire [4:0] next_dec = wave - 1'b1;

// Boundary prediction:
// - When incrementing and wave[3:0] == 4'b1111 (about to hit max)
// - When decrementing and wave[3:0] == 4'b0000 (about to hit min)
wire near_boundary = direction ? ~|wave[3:0] : &wave[3:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update direction one cycle before boundary
        if (near_boundary) begin
            direction <= ~direction;
        end
        
        // Select next value based on current direction
        wave <= direction ? next_dec : next_inc;
    end
end

endmodule