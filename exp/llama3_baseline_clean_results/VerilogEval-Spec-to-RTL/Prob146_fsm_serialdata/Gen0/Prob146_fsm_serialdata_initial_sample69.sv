module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), RECEIVE (1), STOP (2), ERROR (3)
reg [2:0] next_state;
reg [7:0] counter_reg; // Counter for the number of data bits received
reg [7:0] data_reg; // Shift register for the received data bits

// State encoding
localparam IDLE = 3'b001;
localparam RECEIVE = 3'b010;
localparam STOP = 3'b100;
localparam ERROR = 3'b011;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (~in) next_state = RECEIVE;
            else next_state = IDLE;
        end
        RECEIVE: begin
            if (counter_reg == 8) next_state = STOP;
            else next_state = RECEIVE;
        end
        STOP: begin
            if (in) next_state = IDLE;
            else next_state = ERROR;
        end
        ERROR: begin
            if (in) next_state = IDLE;
            else next_state = ERROR;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        counter_reg <= 8'b0;
        data_reg <= 8'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                state_reg <= next_state;
            end
            RECEIVE: begin
                data_reg <= {data_reg[6:0], in}; // Shift in the data bits
                if (counter_reg == 8) begin
                    state_reg <= next_state;
                    out_byte_reg <= data_reg;
                end else begin
                    counter_reg <= counter_reg + 1;
                    state_reg <= next_state;
                end
            end
            STOP: begin
                state_reg <= next_state;
                if (next_state == IDLE) begin
                    done_reg <= 1'b1;
                end else begin
                    done_reg <= 1'b0;
                end
            end
            ERROR: begin
                state_reg <= next_state;
                if (next_state == IDLE) begin
                    counter_reg <= 8'b0;
                    data_reg <= 8'b0;
                end
            end
            default: state_reg <= IDLE;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule