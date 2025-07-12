module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Current state of the FSM
reg [2:0] state;

// Current bit counter
reg [2:0] bit_counter;

// Data register to store the received bits
reg [7:0] data;

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        0: begin // IDLE
            if (!in) begin
                state = 1;
            end
        end
        1: begin // START
            state = 2;
        end
        2: begin // DATA
            if (bit_counter == 8) begin
                state = 3;
            end
        end
        3: begin // STOP
            if (in) begin
                state = 0;
            end
        end
        default: state = 0;
    endcase
end

// Sequential logic to update the registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            1: begin // START
                bit_counter <= 0;
            end
            2: begin // DATA
                data[bit_counter] <= in; // store data bits in the correct order
                bit_counter <= bit_counter + 1;
            end
            3: begin // STOP
                if (in) begin
                    out_byte <= {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
                    done <= 1;
                end
            end
            default: begin
                done <= 0;
            end
        endcase
    end
end

// Combinational logic to determine the done signal
assign done = (state == 3 && in);

endmodule