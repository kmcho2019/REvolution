module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter WIDTH = 8;
    
    // State machine states
    typedef enum logic {
        COLLECT,
        OUTPUT
    } state_t;
    
    reg [2:0] bit_pos;
    reg [7:0] shift_reg;
    reg       valid_pulse;
    state_t   state;
    
    // Continuous assignment for output valid
    assign dout_valid = valid_pulse;
    
    // State machine and shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= COLLECT;
            bit_pos <= 3'b0;
            shift_reg <= 8'b0;
            valid_pulse <= 1'b0;
        end
        else begin
            valid_pulse <= 1'b0;  // Default
            
            case (state)
                COLLECT: begin
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        
                        if (bit_pos == WIDTH-1) begin
                            state <= OUTPUT;
                            bit_pos <= 3'b0;
                        end
                        else begin
                            bit_pos <= bit_pos + 1'b1;
                        end
                    end
                end
                
                OUTPUT: begin
                    dout_parallel <= shift_reg;
                    valid_pulse <= 1'b1;
                    state <= COLLECT;
                end
            endcase
        end
    end

endmodule