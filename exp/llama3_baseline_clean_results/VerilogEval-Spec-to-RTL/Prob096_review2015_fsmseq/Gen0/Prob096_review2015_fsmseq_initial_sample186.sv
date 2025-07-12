module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // Using 2 bits to represent 4 states (00, 01, 10, 11)
assign start_shifting = (state == 2'b11); // Set start_shifting to 1 when in state S4

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to initial state S0
    end else begin
        case(state)
            2'b00: begin // S0
                if (data) begin
                    state <= 2'b01; // Move to S1 if input is '1'
                end else begin
                    state <= 2'b00; // Stay in S0 if input is '0'
                end
            end
            2'b01: begin // S1
                if (data) begin
                    state <= 2'b10; // Move to S2 if input is '1'
                end else begin
                    state <= 2'b00; // Reset to S0 if input is '0'
                end
            end
            2'b10: begin // S2
                if (data) begin
                    state <= 2'b10; // Stay in S2 if input is '1'
                end else begin
                    state <= 2'b11; // Move to S3 if input is '0'
                end
            end
            2'b11: begin // S3
                if (data) begin
                    state <= 2'b01; // Move back to S1 if input is '1'
                end else begin
                    state <= 2'b00; // Reset to S0 if input is '0'
                end
            end
            default: state <= 2'b00; // Invalid state, reset to S0
        endcase
    end
end

// However, to fix the problem description requirement that the start_shifting
// should be 1 forever once the sequence 1101 is detected and stay at that 
// value until reset is applied, we need to change the state transition in 
// state S3 and the condition to set start_shifting to 1 as follows:
always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; 
    end else begin
        case(state)
            2'b00: begin 
                if (data) begin
                    state <= 2'b01; 
                end else begin
                    state <= 2'b00; 
                end
            end
            2'b01: begin 
                if (data) begin
                    state <= 2'b10; 
                end else begin
                    state <= 2'b00; 
                end
            end
            2'b10: begin 
                if (data) begin
                    state <= 2'b10; 
                end else begin
                    state <= 2'b11; 
                end
            end
            2'b11: begin 
                if (data) begin
                    state <= 2'b11; 
                end else begin
                    state <= 2'b11; 
                end
            end
            default: state <= 2'b00; 
        endcase
    end
end

assign start_shifting = (state == 2'b11); 
endmodule