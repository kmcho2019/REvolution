module TopModule (
    input  [3:0] x,
    output       f
);

// Use a function to implement the K-map lookup
function automatic logic kmap_function(input [3:0] addr);
    begin
        // addr = {x[3], x[0], x[1], x[2]}
        case (addr)
            4'b0000: kmap_function = 1'b0; // d -> choose 0
            4'b0001: kmap_function = 1'b0; // 0
            4'b0010: kmap_function = 1'b0; // d -> 0
            4'b0011: kmap_function = 1'b0; // 0 (from K-map)
            
            4'b0100: kmap_function = 1'b0; // 0
            4'b0101: kmap_function = 1'b0; // d -> 0
            4'b0110: kmap_function = 1'b1; // d -> 1 chosen
            4'b0111: kmap_function = 1'b1; // 1
            
            4'b1000: kmap_function = 1'b1; // 1
            4'b1001: kmap_function = 1'b1; // 1
            4'b1010: kmap_function = 1'b0; // d -> 0
            4'b1011: kmap_function = 1'b0; // d -> 0
            
            4'b1100: kmap_function = 1'b1; // 1
            4'b1101: kmap_function = 1'b1; // 1
            4'b1110: kmap_function = 1'b0; // d -> 0
            4'b1111: kmap_function = 1'b0; // d -> 0
            
            default: kmap_function = 1'b0;
        endcase
    end
endfunction

assign f = kmap_function({x[3], x[0], x[1], x[2]});

endmodule