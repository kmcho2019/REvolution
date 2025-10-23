module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] state = 2'b00;  // 3 states: 0,1,2
    reg shared_ff = 0;
    reg [2:0] result_buffer = 3'b000;
    wire current_result;

    // State transition
    always @(posedge clk) begin
        state <= (state == 2'b10) ? 2'b00 : state + 1;
    end

    // Shared flip-flop logic
    assign current_result = (state == 2'b00) ? (x ^ shared_ff) :
                          (state == 2'b01) ? (x & ~shared_ff) :
                          (x | ~shared_ff);

    always @(posedge clk) begin
        shared_ff <= current_result;
        
        // Store results in buffer
        if (state == 2'b00) result_buffer[0] <= current_result;
        if (state == 2'b01) result_buffer[1] <= current_result;
        if (state == 2'b10) result_buffer[2] <= current_result;
    end

    // Output logic (updates every 3 cycles)
    always @(posedge clk) begin
        if (state == 2'b10) begin
            z <= ~(result_buffer[0] | result_buffer[1] | result_buffer[2]);
        end
    end

endmodule