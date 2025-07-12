module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define clusters and micro-states
    localparam CLUSTER_COUNT = 3;
    localparam MICRO_STATE_COUNT = 3;

    // Define cluster boundaries
    localparam CLUSTER_0_BOUNDARY = 2;
    localparam CLUSTER_1_BOUNDARY = 5;
    localparam CLUSTER_2_BOUNDARY = 9;

    // Define micro-state encoding
    reg [MICRO_STATE_COUNT-1:0] micro_state;
    reg [CLUSTER_COUNT-1:0] cluster_select;

    // Implement cluster selection logic
    always @(*) begin
        cluster_select = 1'b0;
        if (state[CLUSTER_0_BOUNDARY]) begin
            cluster_select[0] = 1'b1;
        end else if (state[CLUSTER_1_BOUNDARY]) begin
            cluster_select[1] = 1'b1;
        end else if (state[CLUSTER_2_BOUNDARY]) begin
            cluster_select[2] = 1'b1;
        end
    end

    // Implement micro-state transitions within each cluster
    always @(*) begin
        micro_state = 1'b0;
        case (cluster_select)
            3'b001: begin
                // Cluster 0 transitions
                if (state[0] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[0] && in) begin
                    micro_state[1] = 1'b1;
                end else if (state[1] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[1] && in) begin
                    micro_state[2] = 1'b1;
                end
            end
            3'b010: begin
                // Cluster 1 transitions
                if (state[2] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[2] && in) begin
                    micro_state[1] = 1'b1;
                end else if (state[3] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[3] && in) begin
                    micro_state[2] = 1'b1;
                end
            end
            3'b100: begin
                // Cluster 2 transitions
                if (state[5] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[5] && in) begin
                    micro_state[1] = 1'b1;
                end else if (state[6] &&!in) begin
                    micro_state[0] = 1'b1;
                end else if (state[6] && in) begin
                    micro_state[2] = 1'b1;
                end
            end
        endcase
    end

    // Implement output logic
    always @(*) begin
        out1 = 1'b0;
        out2 = 1'b0;
        case (micro_state)
            3'b001: begin
                // Output logic for micro-state 0
                if (state[7]) begin
                    out2 = 1'b1;
                end
            end
            3'b010: begin
                // Output logic for micro-state 1
                if (state[8]) begin
                    out1 = 1'b1;
                end
            end
            3'b100: begin
                // Output logic for micro-state 2
                if (state[9]) begin
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
            end
        endcase
    end

    // Assign next state
    always @(*) begin
        next_state = 10'b0;
        case (micro_state)
            3'b001: begin
                // Next state for micro-state 0
                next_state[0] = 1'b1;
            end
            3'b010: begin
                // Next state for micro-state 1
                next_state[1] = 1'b1;
            end
            3'b100: begin
                // Next state for micro-state 2
                next_state[2] = 1'b1;
            end
        endcase
    end

endmodule