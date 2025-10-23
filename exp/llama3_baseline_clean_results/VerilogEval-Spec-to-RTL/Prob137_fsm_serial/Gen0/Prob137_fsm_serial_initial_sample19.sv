module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    reg [7:0] data_reg; // register to store the received byte
    reg [2:0] state; // 3-bit state register: idle (3'b000), start (3'b001), data (3'b010), stop (3'b011), error (3'b100)
    reg [2:0] bit_count; // counter for data bits
    wire done_wire; // internal wire for done signal

    // define the states
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;
    parameter ERROR = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done_wire <= 0;
            data_reg <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin // start bit detected
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    data_reg[0] <= in; // store the first data bit
                    state <= DATA;
                    bit_count <= 1;
                end
                DATA: begin
                    if (bit_count < 8) begin
                        data_reg[bit_count] <= in; // store the data bit
                        state <= DATA;
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in) begin // stop bit correct
                        state <= IDLE;
                        done_wire <= 1;
                    end else begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if (in) begin // wait for stop bit
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
            endcase
        end
    end

    assign done = done_wire;

endmodule