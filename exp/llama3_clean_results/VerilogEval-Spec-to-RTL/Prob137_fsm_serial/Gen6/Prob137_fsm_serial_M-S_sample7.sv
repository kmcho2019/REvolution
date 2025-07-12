module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [7:0] data; // Collected data bits
reg [2:0] state; // State machine states: idle (0), start (1), data (2), stop (3)
reg done_reg; // Registered output

always @(posedge clk) begin
    if (reset) begin 
        state <= 3'b000;
        data <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: if (!in) state <= 3'b001; // Start bit detected
            3'b001: begin 
                data <= {data[6:0], in}; 
                state <= 3'b010; 
            end
            3'b010: begin 
                if (data[7]) begin
                    data <= {data[6:0], in}; 
                    state <= (data[7] == 1'b1)? 3'b010 : 3'b000;
                end else begin
                    data <= {data[6:0], in}; 
                    state <= 3'b010; 
                end
            end
            3'b011: begin
                data <= {data[6:0], in};
                state <= 3'b100;
            end
            3'b100: if (in) begin
                    done_reg <= 1'b1; 
                    state <= 3'b000; 
                end else begin
                    state <= 3'b000; // Invalid stop bit, restart
                end
            default: state <= 3'b000; // If state exceeds 3, reset it
        endcase
    end
end

always @(posedge clk) begin
    if (state == 3'b100) begin
        if (data[7] == 1'b1) begin
            done_reg <= 1'b1;
        end
    end
end

assign done = done_reg;

endmodule