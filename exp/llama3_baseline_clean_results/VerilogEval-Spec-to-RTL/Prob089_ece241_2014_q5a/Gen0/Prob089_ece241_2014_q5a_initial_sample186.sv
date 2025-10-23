module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // idle, running
reg [31:0] cumulative_sum; // store cumulative sum of inverted input bits
reg [31:0] output; // store the output
reg [4:0] count; // count the number of bits processed

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // idle state
        cumulative_sum <= 32'd0;
        output <= 32'd0;
        count <= 5'd0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (!areset) begin
                    state <= 2'b01; // transition to running state
                    cumulative_sum <= 32'd0;
                    output <= 32'd0;
                    count <= 5'd0;
                end
            end
            2'b01: begin // running state
                if (areset) begin
                    state <= 2'b00; // transition back to idle state
                end else begin
                    output[count] <= ~x; // invert the input bit
                    cumulative_sum <= cumulative_sum + (~x); // update cumulative sum
                    if (count == 5'd31) begin // if all bits are processed
                        state <= 2'b00; // transition back to idle state
                        z <= output[0]; // output the least significant bit of the 2's complement
                    end else begin
                        count <= count + 5'd1; // increment bit count
                        z <= output[count-1]; // output the current bit of the 2's complement
                    end
                end
            end
        endcase
    end
end

endmodule