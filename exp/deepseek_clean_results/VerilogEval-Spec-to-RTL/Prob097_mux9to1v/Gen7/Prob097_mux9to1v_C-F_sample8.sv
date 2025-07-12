module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

parameter DEFAULT_VAL = 16'hFFFF; // Configurable default value

// First level mux outputs
wire [15:0] mux1_out, mux2_out, mux3_out;

// First level muxes (3:1 each)
assign mux1_out = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b : c;

assign mux2_out = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e : f;

assign mux3_out = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h : i;

// Second level mux (3:1) with input gating and default handling
always @(*) begin
    if (sel[3:2] == 2'b00) begin      // sel 0-3
        out = (sel[1:0] == 2'd3) ? d : mux1_out;
    end
    else if (sel[3:2] == 2'b01) begin // sel 4-7
        out = (sel[1:0] == 2'd3) ? h : mux2_out;
    end
    else if (sel[3:2] == 2'b10) begin // sel 8
        out = (sel[1:0] == 2'd0) ? i : DEFAULT_VAL;
    end
    else begin                        // sel 9-15
        out = DEFAULT_VAL;
    end
end

/* Implementation Notes:
   - Hierarchical muxing improves timing by reducing fan-in
   - Input gating reduces power when sel > 8
   - DEFAULT_VAL parameter allows power optimization (e.g., could use 16'h0000)
   - Further optimizations possible:
     * Use tri-state buffers if supported
     * Pipeline the output register for critical paths
     * Break into smaller bit chunks for area optimization
*/

endmodule