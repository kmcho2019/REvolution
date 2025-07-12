module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Priority encoder to determine which device should be granted access
reg [1:0] grant_index;

always @(*) begin
    if (r[0]) grant_index = 2'b00;
    else if (r[1]) grant_index = 2'b01;
    else if (r[2]) grant_index = 2'b10;
    else grant_index = 2'b11; // Default to no grant
end

// Grant manager to ensure grants remain active while requests are maintained
reg [1:0] current_grant;
reg [2:0] grant_status;

always @(posedge clk) begin
    if (~resetn) begin
        current_grant <= 2'b11; // Reset to no grant
        grant_status <= 3'b000;
    end else begin
        case (grant_index)
            2'b00: begin
                current_grant <= 2'b00;
                grant_status <= {1'b1, 2'b00};
            end
            2'b01: begin
                if (r[1]) begin
                    current_grant <= 2'b01;
                    grant_status <= {2'b0, 1'b1};
                end else begin
                    current_grant <= 2'b11;
                    grant_status <= 3'b000;
                end
            end
            2'b10: begin
                if (r[2]) begin
                    current_grant <= 2'b10;
                    grant_status <= {1'b0, 2'b01};
                end else begin
                    current_grant <= 2'b11;
                    grant_status <= 3'b000;
                end
            end
            default: begin
                current_grant <= 2'b11;
                grant_status <= 3'b000;
            end
        endcase
    end
end

assign g = grant_status;

endmodule