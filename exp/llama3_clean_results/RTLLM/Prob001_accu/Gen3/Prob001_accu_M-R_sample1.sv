module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

// States for the FSM
enum logic [1:0] {IDLE, ACCUMULATING, OUTPUTTING} state, next_state;

// Registers for state, counter, data buffer, and output
reg [1:0] state_reg;
reg [1:0] counter;
reg [7:0] data_buf [3:0];
reg [9:0] data_out_reg;

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = ACCUMULATING;
            end
        end
        ACCUMULATING: begin
            if (counter == 2'd3) begin
                next_state = OUTPUTTING;
            end
        end
        OUTPUTTING: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state, counter, data buffer, and output
always_ff @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= IDLE;
        counter <= 2'd0;
        for (int i = 0; i < 4; i++) begin
            data_buf[i] <= 8'd0;
        end
        data_out_reg <= 10'd0;
    end else begin
        state_reg <= next_state;
        case (state_reg)
            IDLE: begin
                counter <= 2'd0;
                data_out_reg <= 10'd0;
            end
            ACCUMULATING: begin
                if (valid_in) begin
                    data_buf[counter] <= data_in;
                    if (counter == 2'd3) begin
                        data_out_reg <= data_buf[0] + data_buf[1] + data_buf[2] + data_buf[3];
                    end
                    counter <= counter + 1'd1;
                end
            end
            OUTPUTTING: begin
                // No action needed, just transition back to IDLE
            end
        endcase
    end
end

// Output logic
assign valid_out = (state_reg == OUTPUTTING);
assign data_out = data_out_reg;

endmodule