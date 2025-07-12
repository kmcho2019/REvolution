module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] preload;
    reg state;

    localparam IDLE = 1'b0;
    localparam COUNTING = 1'b1;

    always @(posedge clk) begin
        if (load) begin
            preload <= data;
            counter <= data;
            state <= (|data) ? COUNTING : IDLE;
        end else begin
            case (state)
                COUNTING: begin
                    counter <= counter - 1;
                    if (counter == 1) state <= IDLE;
                end
                IDLE: counter <= 0;
            endcase
        end
    end

    assign tc = (state == IDLE);

endmodule