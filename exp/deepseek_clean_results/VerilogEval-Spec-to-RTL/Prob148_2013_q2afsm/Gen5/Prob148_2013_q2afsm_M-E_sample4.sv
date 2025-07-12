module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: {current_grant[1:0], priority_offset[1:0]}
    // current_grant: 00=none, 01=dev0, 10=dev1, 11=dev2
    // priority_offset: rotation counter (0-2)
    reg [2:0] state;
    
    // Next state calculation
    wire [1:0] current_grant = state[2:1];
    wire [1:0] priority_offset = state[0] ? 2'd1 : (state[1] ? 2'd2 : 2'd0);
    wire [1:0] next_grant;
    
    // Arbitration logic
    always @(*) begin
        // Default: no grant
        next_grant = 2'b00;
        
        // First check if current grantee still requesting
        if (|current_grant && r[current_grant-1]) begin
            next_grant = current_grant;
        end
        else begin
            // Check requests in rotating priority order
            case (priority_offset)
                2'd0: begin
                    if (r[0]) next_grant = 2'b01;
                    else if (r[1]) next_grant = 2'b10;
                    else if (r[2]) next_grant = 2'b11;
                end
                2'd1: begin
                    if (r[1]) next_grant = 2'b10;
                    else if (r[2]) next_grant = 2'b11;
                    else if (r[0]) next_grant = 2'b01;
                end
                2'd2: begin
                    if (r[2]) next_grant = 2'b11;
                    else if (r[0]) next_grant = 2'b01;
                    else if (r[1]) next_grant = 2'b10;
                end
            endcase
        end
    end
    
    // State update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b000; // No grant, priority offset 0
        end
        else begin
            // Update grant and rotate priority if granting to new device
            if (next_grant != current_grant && next_grant != 0) begin
                state <= {next_grant, priority_offset + 1'b1};
            end
            else begin
                state <= {current_grant, priority_offset};
            end
        end
    end
    
    // Output generation
    assign g = (current_grant == 2'b01) ? 3'b001 :
               (current_grant == 2'b10) ? 3'b010 :
               (current_grant == 2'b11) ? 3'b100 :
               3'b000;

endmodule