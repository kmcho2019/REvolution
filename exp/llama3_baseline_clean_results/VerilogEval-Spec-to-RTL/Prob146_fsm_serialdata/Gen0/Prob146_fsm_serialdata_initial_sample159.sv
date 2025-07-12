module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte;
    reg [2:0] state;
    reg [2:0] count;
    reg [7:0] data;

    // Define states
    localparam IDLE = 3'b001;
    localparam START = 3'b010;
    localparam DATA = 3'b011;
    localparam STOP = 3'b100;

    // Initialize state and count
    initial begin
        state = IDLE;
        count = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            state = IDLE;
            count = 0;
            out_byte = 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state = START;
                    end
                end
                START: begin
                    data[0] = in;
                    state = DATA;
                    count = 1;
                end
                DATA: begin
                    if (count < 8) begin
                        data[count] = in;
                        count = count + 1;
                    end else begin
                        data[7] = in;
                        state = STOP;
                    end
                end
                STOP: begin
                    if (in) begin
                        out_byte = data;
                        done = 1'b1;
                        state = IDLE;
                    end
                end
                default: state = IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == IDLE) begin
            done = 1'b0;
        end
    end

endmodule