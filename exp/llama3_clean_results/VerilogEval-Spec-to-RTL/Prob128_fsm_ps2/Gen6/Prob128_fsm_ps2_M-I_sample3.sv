module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;
logic [1:0] byte_counter;

always_comb begin
    if (state == 0 && in[3]) begin
        state = 1;
        byte_counter = 1;
    end else if (state == 1) begin
        state = 2;
        byte_counter = 2;
    end else if (state == 2) begin
        state = 0;
        byte_counter = 0;
    end else if (in[3] && state != 0) begin
        state = 1;
        byte_counter = 1;
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;
        byte_counter <= 0;
        done <= 0;
    end else begin
        if (byte_counter == 2) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule