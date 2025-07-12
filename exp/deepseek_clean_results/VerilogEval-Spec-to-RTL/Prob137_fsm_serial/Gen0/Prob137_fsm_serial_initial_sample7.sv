module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP = 2'b10;
    localparam ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] data_shift;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
            data_shift <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                end
                
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // Shift in LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin
                        done_reg <= 1'b1; // Valid stop bit
                    end
                end
                
                ERROR: begin
                    if (in) begin
                        done_reg <= 1'b0; // Found stop bit, can return to IDLE
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE; // Valid stop bit
                end else begin
                    next_state = ERROR; // Missing stop bit
                end
            end
            
            ERROR: begin
                next_state = in ? IDLE : ERROR; // Wait for stop bit
            end
            
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule