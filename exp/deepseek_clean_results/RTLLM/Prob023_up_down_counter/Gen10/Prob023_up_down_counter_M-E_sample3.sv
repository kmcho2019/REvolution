module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code portion (8 LSBs)
reg [7:0] gray_count;
wire [7:0] next_gray;

// Binary portion (8 MSBs)
reg [7:0] binary_count;
wire binary_carry;

// Gray code next state logic
assign next_gray = up_down ? 
    ((gray_count == 8'hFF) ? 8'h00 : gray_count ^ {1'b0, gray_count[7:1]}) :
    ((gray_count == 8'h00) ? 8'hFF : gray_count ^ {1'b0, ~gray_count[7:1]});

// Binary carry generation
assign binary_carry = up_down ? 
    (gray_count == 8'hFF) : 
    (gray_count == 8'h00);

// Gray counter update
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 8'h00;
    end else begin
        gray_count <= next_gray;
    end
end

// Binary counter update
always @(posedge clk) begin
    if (reset) begin
        binary_count <= 8'h00;
    end else if (binary_carry) begin
        if (up_down) begin
            binary_count <= binary_count + 1'b1;
        end else begin
            binary_count <= binary_count - 1'b1;
        end
    end
end

// Output combination
always @(*) begin
    // Convert gray_count to binary for lower 8 bits
    count[7:0] = {gray_count[7],
                 gray_count[7] ^ gray_count[6],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5] ^ gray_count[4],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5] ^ gray_count[4] ^ gray_count[3],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5] ^ gray_count[4] ^ gray_count[3] ^ gray_count[2],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5] ^ gray_count[4] ^ gray_count[3] ^ gray_count[2] ^ gray_count[1],
                 gray_count[7] ^ gray_count[6] ^ gray_count[5] ^ gray_count[4] ^ gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0]};
    
    // Direct binary for upper 8 bits
    count[15:8] = binary_count;
end

endmodule