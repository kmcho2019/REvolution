module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [1:0] state; // 0 - idle, 1 - inverting, 2 - adding
reg [31:0] num; // To store the binary number (assuming 32 bits max for simplicity)
reg [31:0] inverted_num; // To store the inverted binary number
reg carry; // Carry flag for adding 1
reg [4:0] bit_count; // Counter to keep track of the current bit position

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0;
        num <= 0;
        inverted_num <= 0;
        carry <= 0;
        bit_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // Idle state
                if(!areset) begin
                    state <= 1;
                    num <= 0;
                    inverted_num <= 0;
                    carry <= 0;
                    bit_count <= 0;
                end
            end
            1: begin // Inverting state
                num[bit_count] <= x;
                inverted_num[bit_count] <= ~x;
                bit_count <= bit_count + 1;
                z <= ~x;
            end
            2: begin // Adding state
                if(carry) begin
                    inverted_num[bit_count] <= ~inverted_num[bit_count];
                    carry <= inverted_num[bit_count];
                end
                z <= inverted_num[bit_count];
                bit_count <= bit_count + 1;
            end
        endcase
    end
end

always @(negedge areset) begin
    if(!areset) begin
        state <= 0;
    end
end

always @(posedge clk) begin
    if(state == 1 && areset) begin
        if(x == 1) begin
            carry <= 1;
            state <= 2;
        end
    end
end

endmodule