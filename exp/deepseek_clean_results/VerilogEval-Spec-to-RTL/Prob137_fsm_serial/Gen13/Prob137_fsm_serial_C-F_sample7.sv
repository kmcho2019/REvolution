module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (binary for minimal area)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            // Default assignments
            shift_enable <= 1'b0;
            done_reg <= 1'b0;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (!in) begin
                        state <= RECEIVE;
                        shift_enable <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    shift_enable <= 1'b1;
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                        shift_enable <= 1'b0;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        state <= IDLE;
                        done_reg <= 1'b1;  // Valid stop bit
                    end else begin
                        state <= WAIT;
                    end
                end
                
                WAIT: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule