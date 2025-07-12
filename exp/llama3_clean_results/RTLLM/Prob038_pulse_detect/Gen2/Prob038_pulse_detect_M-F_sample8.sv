module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Maintain the current 2-bit encoding for simplicity and minimalism
reg [1:0] state; 
localparam IDLE = 2'b00; 
localparam RISING = 2'b01; 
localparam HIGH = 2'b10; 
localparam FALLING = 2'b11; 

// Maintain synchronous reset for its benefits in power and area optimization
always @(posedge clk) begin
    if (!rst_n) begin 
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin 
                    state <= RISING;
                end else begin
                    state <= IDLE; 
                end
                data_out <= 0; 
            end
            RISING: begin
                if (data_in) begin 
                    state <= HIGH;
                end else begin
                    state <= IDLE; 
                end
            end
            HIGH: begin
                if (~data_in) begin 
                    state <= FALLING;
                end else begin
                    state <= HIGH; 
                end
            end
            FALLING: begin
                if (~data_in) begin 
                    state <= IDLE;
                    data_out <= 1; 
                end else begin
                    state <= IDLE; 
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule