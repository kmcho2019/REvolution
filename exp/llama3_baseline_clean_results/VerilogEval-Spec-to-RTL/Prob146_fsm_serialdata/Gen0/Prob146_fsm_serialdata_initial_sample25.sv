module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data;
reg [2:0] state; // IDLE, STARTED, DATA, STOP
reg [2:0] next_state;
reg [3:0] bit_count;
reg done_int;

always @(*) begin
    case(state)
        3'b000: // IDLE
            if (~in) begin // start bit detected
                next_state = 3'b001; // STARTED
                bit_count = 0;
            end
            else begin
                next_state = 3'b000; // IDLE
            end
        3'b001: // STARTED
            next_state = 3'b010; // DATA
        3'b010: // DATA
            if (bit_count == 7) begin
                next_state = 3'b011; // STOP
            end
            else begin
                next_state = 3'b010; // DATA
            end
        3'b011: // STOP
            if (in) begin // stop bit detected
                next_state = 3'b000; // IDLE
                done_int = 1'b1;
            end
            else begin
                next_state = 3'b011; // STOP (wait for stop bit)
            end
        default:
            next_state = 3'b000; // IDLE
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        data <= 8'b0;
        bit_count <= 0;
        done_int <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;
        case(state)
            3'b010: // DATA
                begin
                    data <= {data[6:0], in}; // shift data in
                    bit_count <= bit_count + 1;
                end
        endcase
        if (done_int) begin
            out_byte <= data;
            done <= 1'b1;
        end
        else begin
            done <= 0;
        end
        done_int <= 0;
    end
end

endmodule