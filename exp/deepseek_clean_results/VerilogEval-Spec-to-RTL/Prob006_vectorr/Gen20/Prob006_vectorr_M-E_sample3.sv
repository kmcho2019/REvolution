module TopModule (
    input [7:0] in,
    output reg [7:0] out
);

    reg [7:0] shift_reg;
    reg [2:0] bit_counter;
    reg load;
    
    // Simple FSM states
    localparam IDLE = 1'b0;
    localparam PROCESS = 1'b1;
    reg state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out <= 8'b0;
            bit_counter <= 3'b0;
            load <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (in_valid) begin  // Assuming an input valid signal
                        shift_reg <= in;
                        bit_counter <= 3'd7;
                        load <= 1'b1;
                        state <= PROCESS;
                    end
                end
                
                PROCESS: begin
                    load <= 1'b0;
                    out[bit_counter] <= shift_reg[0];  // Store LSB in current position
                    shift_reg <= {1'b0, shift_reg[7:1]};  // Right shift
                    
                    if (bit_counter == 3'b0) begin
                        state <= IDLE;
                    end
                    else begin
                        bit_counter <= bit_counter - 1;
                    end
                end
            endcase
        end
    end
    
    // Combinational version for comparison (can be removed)
    // assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    
endmodule