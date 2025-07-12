module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State parameters
    parameter IDLE = 2'b00;
    parameter ACC1 = 2'b01;
    parameter ACC2 = 2'b10;
    parameter ACC3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accum;
    wire [9:0] next_accum;

    // Next state and accumulation logic
    always @(*) begin
        next_state = state;
        next_accum = accum;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACC1;
                    next_accum = data_in;
                end
                ACC1: begin
                    next_state = ACC2;
                    next_accum = accum + data_in;
                end
                ACC2: begin
                    next_state = ACC3;
                    next_accum = accum + data_in;
                end
                ACC3: begin
                    next_state = IDLE;
                    next_accum = accum + data_in;
                end
            endcase
        end
    end

    // State and accumulator registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum <= 10'b0;
        end else begin
            state <= next_state;
            accum <= next_accum;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= (state == ACC3) && valid_in;
            data_out <= ((state == ACC3) && valid_in) ? (accum + data_in) : data_out;
        end
    end

endmodule