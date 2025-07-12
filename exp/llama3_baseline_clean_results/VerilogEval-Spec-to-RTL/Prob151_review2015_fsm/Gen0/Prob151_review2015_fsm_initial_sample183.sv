module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
parameter IDLE    = 4'b0000;
parameter SHIFT   = 4'b0001;
parameter COUNT   = 4'b0010;
parameter DONE_W  = 4'b0011;
parameter DONE    = 4'b0100;

// State register
reg [3:0] state;
reg [3:0] next_state;

// Flag to check if pattern is detected
reg pattern_detected;

// Counter for shifting
reg [1:0] shift_count;

// Initialize state
initial state = IDLE;

// Pattern detection logic
reg [3:0] data_reg;
always @(posedge clk) begin
    if(reset) begin
        data_reg <= 4'b0000;
        pattern_detected <= 1'b0;
    end else begin
        data_reg <= {data_reg[2:0], data};
        if(data_reg == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end
end

// Next state logic
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 2'b00;
    end else begin
        case(state)
            IDLE: begin
                if(pattern_detected) begin
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= 2'b00;
                end else begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            end
            SHIFT: begin
                if(shift_count == 2'b11) begin
                    state <= COUNT;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end else begin
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNT: begin
                if(done_counting) begin
                    state <= DONE_W;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end else begin
                    state <= COUNT;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
            end
            DONE_W: begin
                state <= DONE;
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
            DONE: begin
                if(ack) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end else begin
                    state <= DONE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

endmodule