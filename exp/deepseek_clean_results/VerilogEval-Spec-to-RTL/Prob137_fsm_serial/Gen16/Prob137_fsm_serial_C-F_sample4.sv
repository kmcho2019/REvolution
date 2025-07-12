module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot encoded states (4 bits)
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;
    reg shift_enable;

    // Clock-gated shift register
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (shift_enable) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 1'b0;
        end else begin
            done_reg <= (state == STOP) && (in == 1'b1);
        end
    end

    // Combinational next state and control logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        
        case (1'b1)  // Synopsys parallel_case
            state[0]: begin  // IDLE
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            
            state[1]: begin  // RECEIVE
                shift_enable = 1'b1;
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end
            end
            
            state[2]: begin  // STOP
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            state[3]: begin  // WAIT
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign done = done_reg;

endmodule