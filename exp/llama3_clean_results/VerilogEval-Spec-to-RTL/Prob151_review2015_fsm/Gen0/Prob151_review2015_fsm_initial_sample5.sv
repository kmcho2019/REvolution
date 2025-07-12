module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] seq_reg;  // 4-bit shift register for sequence detection
reg [1:0] shift_cnt;  // counter for number of shifts
reg [1:0] state;  // state variable: 0 - IDLE, 1 - SHIFT, 2 - COUNT, 3 - DONE

// Define states
localparam IDLE = 2'd0;
localparam SHIFT = 2'd1;
localparam COUNT = 2'd2;
localparam DONE_STATE = 2'd3;

always @(posedge clk) begin
    if (reset) begin
        seq_reg <= 4'd0;
        shift_cnt <= 2'd0;
        state <= IDLE;
        shift_ena <= 1'd0;
        counting <= 1'd0;
        done <= 1'd0;
    end else begin
        case (state)
            IDLE: begin
                seq_reg <= {seq_reg[2:0], data};  // shift in new data
                if (seq_reg == 4'd13) begin  // 1101 detected
                    state <= SHIFT;
                    shift_cnt <= 2'd0;
                    shift_ena <= 1'd1;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 2'd4) begin  // 4 shifts done
                    state <= COUNT;
                    counting <= 1'd1;
                    shift_ena <= 1'd0;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_STATE;
                    done <= 1'd1;
                    counting <= 1'd0;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'd0;
                end
            end
        endcase
    end
end

endmodule