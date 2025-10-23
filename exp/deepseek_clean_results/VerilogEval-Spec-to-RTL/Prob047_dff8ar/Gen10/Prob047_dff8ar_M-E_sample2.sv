module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] ff [0:7];  // 8 flip-flops, each 8 bits wide
reg [2:0] counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Clear all flip-flops and reset counter
        for (integer i = 0; i < 8; i = i + 1) begin
            ff[i] <= 8'b0;
        end
        counter <= 3'b0;
    end
    else begin
        // Update only one flip-flop per clock cycle
        ff[counter] <= d;
        counter <= counter + 1;
    end
end

// Parallel output assignment
assign q = {ff[7], ff[6], ff[5], ff[4], ff[3], ff[2], ff[1], ff[0]};

endmodule