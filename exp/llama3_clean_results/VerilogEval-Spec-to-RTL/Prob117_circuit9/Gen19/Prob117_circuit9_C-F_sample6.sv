module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Define the sequential logic
always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when a is high
    end else begin
        case (q)
            4: q <= 5;
            5: q <= 6;
            6: q <= 0;
            0: q <= 1;
            1: q <= 2;
            2: q <= 3;
            3: q <= 4;
            default: q <= 4;
        endcase
    end
end

endmodule