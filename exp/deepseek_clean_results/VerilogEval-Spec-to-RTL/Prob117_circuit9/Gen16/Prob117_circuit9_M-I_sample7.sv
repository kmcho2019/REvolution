module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;
wire [2:0] next_counter;
wire gated_clk;

// Clock gating when a is high (counter remains at 4)
assign gated_clk = clk & (~a | (counter != 3'd4));

// Gray code counter logic
function [2:0] bin2gray;
    input [2:0] b;
    begin
        bin2gray = {b[2], b[2] ^ b[1], b[1] ^ b[0]};
    end
endfunction

function [2:0] gray2bin;
    input [2:0] g;
    begin
        gray2bin = {g[2], g[2] ^ g[1], g[2] ^ g[1] ^ g[0]};
    end
endfunction

// Combinational next state logic
assign next_counter = a ? 3'd4 : 
                    (gray2bin(counter) == 3'd6) ? bin2gray(3'd0) : 
                    bin2gray(gray2bin(counter) + 1'b1);

// Sequential logic with gated clock
always @(posedge gated_clk) begin
    counter <= next_counter;
    q <= gray2bin(counter);  // Registered output for timing
end

// Initial condition to match waveform
initial begin
    counter = bin2gray(3'd4);
    q = 3'd4;
end

endmodule