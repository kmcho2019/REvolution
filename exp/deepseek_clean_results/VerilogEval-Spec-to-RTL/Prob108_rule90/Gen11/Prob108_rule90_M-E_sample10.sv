module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] shift_reg;
    reg [8:0] counter;
    reg processing;
    wire [511:0] next_q;
    
    // State machine states
    localparam IDLE = 1'b0;
    localparam PROCESS = 1'b1;
    reg state;
    
    // Shift register processing
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= q;
                    counter <= 0;
                    processing <= 1'b1;
                    state <= PROCESS;
                end
                PROCESS: begin
                    if (counter < 511) begin
                        // Shift and process one position
                        shift_reg <= {shift_reg[510:0], 1'b0};
                        counter <= counter + 1;
                    end else begin
                        // Processing complete
                        q <= next_q;
                        processing <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    // Rule 90 computation
    assign next_q = (shift_reg << 1) ^ (shift_reg >> 1);
    
endmodule