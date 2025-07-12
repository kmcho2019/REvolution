module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state;
    reg [7:0] data_reg;
    reg done_pulse;
    reg [7:0] shift_reg;  // Acts as both data storage and bit counter

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            done_pulse <= 1'b0;
            shift_reg <= 8'b0;
        end else begin
            done_pulse <= 1'b0;  // Default assignment
            
            case (1'b1)  // Synthesis will optimize this for one-hot
                state[0]: begin  // IDLE
                    if (!in) begin
                        state <= RECEIVE;
                        shift_reg <= 8'b1;  // Initialize shift register
                    end
                end
                
                state[1]: begin  // RECEIVE
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    shift_reg <= {shift_reg[6:0], 1'b0};  // Shift left
                    
                    if (shift_reg[7]) begin  // All bits received
                        state <= STOP;
                    end
                end
                
                state[2]: begin  // STOP
                    if (in) begin
                        done_pulse <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT;
                    end
                end
                
                state[3]: begin  // WAIT
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // One-cycle pulse generation for done signal
    reg done_reg;
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 1'b0;
        end else begin
            done_reg <= done_pulse;
        end
    end

    assign done = done_reg;

endmodule