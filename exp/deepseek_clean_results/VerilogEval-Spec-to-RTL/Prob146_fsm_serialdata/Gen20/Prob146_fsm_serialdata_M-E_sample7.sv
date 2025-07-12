module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states - 3 states encoded in 2 bits
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count_gray;  // Gray coded counter
    reg [7:0] shift_reg;
    reg [7:0] output_reg;
    reg shift_enable;

    // Gray code increment function
    function [2:0] gray_inc;
        input [2:0] gray;
        reg [2:0] bin;
        begin
            bin = gray ^ (gray >> 1);  // Convert to binary
            bin = bin + 1;              // Increment
            gray_inc = bin ^ (bin >> 1); // Convert back to Gray
        end
    endfunction

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count_gray <= 3'b000;
            shift_reg <= 8'b0;
            output_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count_gray <= 3'b000;
                    if (in == 0) begin
                        shift_reg <= 8'b0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]};  // Right shift
                        bit_count_gray <= gray_inc(bit_count_gray);
                    end
                end
                
                STOP: begin
                    if (in == 1) begin
                        output_reg <= shift_reg;  // Parallel load to output
                    end
                end
            endcase
        end
    end

    // Next state logic with early stop detection
    always @(*) begin
        shift_enable = 0;
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                // Check for last data bit one cycle early
                if ((bit_count_gray == 3'b110) && (gray_inc(bit_count_gray) == 3'b111)) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                next_state = (in == 1) ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Combinatorial done signal (reduces clock load)
    assign done = (state == STOP) && (in == 1);
    assign out_byte = output_reg;

endmodule