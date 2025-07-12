module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE        = 2'b00;
    localparam RECEIVE     = 2'b01;
    localparam STOP_WAIT   = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Combinational next state and output logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP_WAIT;
                end
            end
            
            STOP_WAIT: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1;
                end
            end
        endcase
    end

endmodule