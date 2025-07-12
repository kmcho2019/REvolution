module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;

    always @(*) begin
        if (load) begin
            next_counter = data;
        end else begin
            if (counter != 0)
                next_counter = counter - 1;
            else
                next_counter = 0;
        end
    end

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule