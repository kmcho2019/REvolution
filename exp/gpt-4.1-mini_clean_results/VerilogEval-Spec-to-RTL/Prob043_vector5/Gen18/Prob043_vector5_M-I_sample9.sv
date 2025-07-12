module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a,b,c,d,e};

    // Function to compute index in out vector based on i,j
    // out index = 5*(4 - i) + (4 - j)
    function integer idx;
        input integer i, j;
        begin
            idx = 5*(4 - i) + (4 - j);
        end
    endfunction

    reg [24:0] out_reg;

    integer i, j;
    always @(*) begin
        // Initialize output bits to zero
        out_reg = 25'b0;

        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                if(i <= j) begin
                    // Compute equality for upper triangle and diagonal
                    out_reg[idx(i,j)] = ~(inputs[i] ^ inputs[j]);
                end else begin
                    // Reuse symmetric value for lower triangle
                    out_reg[idx(i,j)] = out_reg[idx(j,i)];
                end
            end
        end
    end

    assign out = out_reg;

endmodule