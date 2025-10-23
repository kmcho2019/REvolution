module TopModule (
    input [7:0] in,
    output reg [7:0] out,
    output reg ready
);

    reg [7:0] shift_reg;
    reg [2:0] counter;
    reg state;

    localparam IDLE = 1'b0;
    localparam PROCESS = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            counter <= 3'b0;
            out <= 8'b0;
            ready <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= in;
                    counter <= 3'd7;
                    state <= PROCESS;
                    ready <= 1'b0;
                end
                PROCESS: begin
                    out[counter] <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    if (counter == 0) begin
                        state <= IDLE;
                        ready <= 1'b1;
                    end else begin
                        counter <= counter - 1;
                    end
                end
            endcase
        end
    end

endmodule