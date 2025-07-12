module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states
localparam IDLE = 3'b001;
localparam RECEIVE_DATA = 3'b010;
localparam VERIFY_STOP = 3'b100;

// Declare the state register
reg [2:0] state;
reg [2:0] next_state;

// Declare a counter to keep track of the received bits
reg [2:0] bit_counter;

// Declare a register to store the received data
reg [7:0] data;

always @(*) begin
    case(state)
        IDLE: begin
            if (in == 0) begin
                next_state = RECEIVE_DATA;
            end else begin
                next_state = IDLE;
            end
        end
        RECEIVE_DATA: begin
            if (bit_counter == 7) begin
                next_state = VERIFY_STOP;
            end else begin
                next_state = RECEIVE_DATA;
            end
        end
        VERIFY_STOP: begin
            if (in == 1) begin
                next_state = IDLE;
            end else begin
                next_state = VERIFY_STOP;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        data <= 0;
        out_byte <= 0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                state <= next_state;
            end
            RECEIVE_DATA: begin
                state <= next_state;
                data <= {data[6:0], in};
                bit_counter <= bit_counter + 1;
            end
            VERIFY_STOP: begin
                state <= next_state;
                if (in == 1) begin
                    out_byte <= data;
                    done <= 1;
                end else begin
                    done <= 0;
                end
            end
            default: state <= IDLE;
        endcase
        if (state == IDLE && next_state == IDLE) begin
            done <= 0;
        end
        if (state == IDLE && next_state == RECEIVE_DATA) begin
            bit_counter <= 1;
        end
        if (state == RECEIVE_DATA && next_state == VERIFY_STOP) begin
            bit_counter <= 0;
        end
        if (state == VERIFY_STOP && next_state == IDLE) begin
            bit_counter <= 0;
            done <= 1;
        end
    end
end

endmodule