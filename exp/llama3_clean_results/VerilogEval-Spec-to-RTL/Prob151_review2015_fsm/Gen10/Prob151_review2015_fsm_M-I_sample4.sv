module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
localparam RESET = 4'b0000;
localparam IDLE = 4'b0001;
localparam SHIFT = 4'b0010;
localparam COUNT = 4'b0011;
localparam DONE = 4'b0100;

reg [3:0] state;
reg [3:0] pattern;
reg [3:0] shift_data;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= RESET;
        pattern <= 4'b0000;
        shift_data <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        case (state)
            RESET: begin
                state <= IDLE;
            end
            IDLE: begin
                // Pattern detection
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00; // Reset shift count
                end
            end
            SHIFT: begin
                // Shift data
                shift_data[3:1] <= shift_data[2:0];
                shift_data[0] <= data;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin // Shifted 4 times
                    state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
        end
        COUNT: begin
            shift_ena = 1'b0;
        end
        DONE: begin
            shift_ena = 1'b0;
        end
        default: begin
            shift_ena = 1'b0;
        end
    endcase
end

endmodule