module TopModule(
    input           clk,
    input           areset,
    input           x,
    output          z
);

reg [31:0] accumulator;  // accumulator to store input bits
reg [4:0]  count;        // counter to keep track of number of bits accumulated
reg        is_signed;    // flag to check if number is negative
reg [31:0] temp;         // temporary register to store 2's complement

// State register
reg [1:0] state, next_state;

// Define states
localparam IDLE = 2'b00;
localparam ACCUMULATE = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        accumulator <= 32'b0;
        count <= 5'b0;
        is_signed <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if (~areset) begin
                    state <= ACCUMULATE;
                    count <= 5'b1;
                    accumulator <= {31'b0, x};
                end
            end
            ACCUMULATE: begin
                if (x == 1'b1) begin // check for most significant bit
                    is_signed <= 1'b1;
                end
                accumulator <= {accumulator[30:0], x};
                count <= count + 1'b1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == ACCUMULATE && count == 5'b100000) begin // 32 bits accumulated
        if (is_signed) begin
            // calculate 2's complement
            temp = ~accumulator + 1'b1;
            z <= temp[0]; // output least significant bit of 2's complement
        end else begin
            z <= accumulator[0]; // output least significant bit of original number
        end
    end else if (state == ACCUMULATE && count < 5'b100000) begin
        z <= 1'b0; // output 0 until 2's complement is calculated
    end else begin
        z <= 1'b0; // output 0 when in idle state
    end
end

always @(posedge clk) begin
    if (state == ACCUMULATE && count == 5'b100001) begin // reset after 33 clock cycles
        state <= IDLE;
        accumulator <= 32'b0;
        count <= 5'b0;
        is_signed <= 1'b0;
    end
end

endmodule