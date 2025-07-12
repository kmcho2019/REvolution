module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // State encoding
    localparam IDLE = 1'b0, COUNT = 1'b1;

    reg [9:0] counter;
    reg state;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            state <= COUNT;
        end else begin
            case (state)
                COUNT: begin
                    if (counter != 0)
                        counter <= counter - 1;
                    if (counter == 1)
                        state <= IDLE;
                end
                IDLE: begin
                    counter <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

    assign tc = (state == IDLE);

endmodule