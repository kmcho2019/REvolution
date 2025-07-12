module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] current_state;

// Define states
localparam B = 1'b1;
localparam A = 1'b0;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= B;
        out <= 1'b1;
    end else begin
        case(current_state)
            B: begin
                if(!in) begin
                    current_state <= A;
                    out <= 1'b0;
                end else begin
                    current_state <= B;
                    out <= 1'b1;
                end
            end
            A: begin
                if(!in) begin
                    current_state <= B;
                    out <= 1'b1;
                end else begin
                    current_state <= A;
                    out <= 1'b0;
                end
            end
            default: begin
                current_state <= B;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule