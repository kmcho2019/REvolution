module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg state; // 0: IDLE, 1: COUNTING

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            state <= 1'b1; // Move to COUNTING
        end
        else if (state) begin // In COUNTING state
            if (counter == 10'b0) begin
                state <= 1'b0; // Move to IDLE
            end
            else begin
                counter <= counter - 1'b1;
            end
        end
    end

    assign tc = ~state; // tc is high in IDLE state

endmodule