module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    // Define the states
    parameter IDLE = 0;
    parameter START = 1;
    parameter DATA = 2;
    parameter STOP = 3;

    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] count;
    reg done_reg;

    // Initialize the state and data
    initial begin
        state = IDLE;
        data = 8'b0;
        count = 3'b0;
        done_reg = 1'b0;
    end

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    state <= DATA;
                end
                DATA: begin
                    if (count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        data <= {data[6:0], in};
                        count <= count + 1'b1;
                        state <= DATA;
                    end
                end
                STOP: begin
                    if (in) begin
                        done_reg <= 1'b1;
                        out_byte <= data;
                        state <= IDLE;
                    end else begin
                        state <= STOP;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (done_reg) begin
            done <= 1'b1;
            done_reg <= 1'b0;
        end else begin
            done <= 1'b0;
        end
    end

endmodule