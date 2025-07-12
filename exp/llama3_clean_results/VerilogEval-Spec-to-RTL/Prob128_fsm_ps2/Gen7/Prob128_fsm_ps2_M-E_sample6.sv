module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] byte_counter;
logic        new_message_boundary;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_counter <= 2'b00;
        new_message_boundary <= 1'b0;
    end
    else begin
        if(new_message_boundary) begin
            byte_counter <= 2'b01;
            new_message_boundary <= 1'b0;
        end
        else begin
            byte_counter <= byte_counter + 1'b1;
        end
    end
end

always_comb begin
    if(reset) begin
        new_message_boundary = 1'b0;
    end
    else begin
        new_message_boundary = in[3];
    end
end

always_comb begin
    if(reset) begin
        done = 1'b0;
    end
    else begin
        done = (byte_counter == 2'b10);
    end
end

endmodule