module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

// Combined control signal for case statement
wire [1:0] ctrl = {train_valid, train_taken};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;  // Reset to weakly not-taken
    end
    else begin
        case (state)
            S0: state <= (ctrl == 2'b11) ? S1 : S0;
            S1: state <= (ctrl == 2'b11) ? S2 : 
                         (ctrl == 2'b10) ? S0 : S1;
            S2: state <= (ctrl == 2'b11) ? S3 : 
                         (ctrl == 2'b10) ? S1 : S2;
            S3: state <= (ctrl == 2'b10) ? S2 : S3;
            default: state <= S1;
        endcase
    end
end

endmodule