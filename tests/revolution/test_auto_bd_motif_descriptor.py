import pytest

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values


def test_motif_occupancy_counts_families_and_diversity():
    values = motif_occupancy_descriptor_values(
        """
        module top(input a, input b, input s, output y);
          NAND2_X1 g0 (.A(a), .B(b), .ZN(n1));
          INV_X1 g1 (.A(n1), .ZN(n2));
          MUX2_X1 g2 (.A(n1), .B(n2), .S(s), .Z(y));
          ADD_X1 g3 (.A(a), .B(b), .SUM(n3));
        endmodule
        """
    )

    assert values["motif_logic_ratio"] == pytest.approx(0.5)
    assert values["motif_control_ratio"] == pytest.approx(0.25)
    assert values["motif_arith_ratio"] == pytest.approx(0.25)
    assert 0.0 < values["motif_diversity"] <= 1.0


def test_motif_occupancy_ignores_instance_and_net_renaming():
    original = """
    NAND2_X1 u0 (.A(a), .B(b), .ZN(n1));
    INV_X1 u1 (.A(n1), .ZN(y));
    """
    renamed = """
    INV_X1 renamed1 (.A(temp), .ZN(out));
    NAND2_X1 renamed0 (.A(x), .B(z), .ZN(temp));
    """

    assert motif_occupancy_descriptor_values(original) == motif_occupancy_descriptor_values(
        renamed
    )


def test_motif_occupancy_ignores_formatting_and_comments():
    compact = "NAND2_X1 u0 (.A(a), .B(b), .ZN(y));"
    formatted = """
    // formatting should not change motif occupancy
    NAND2_X1
      u0
      (
        .A(a),
        .B(b),
        .ZN(y)
      );
    """

    assert motif_occupancy_descriptor_values(compact) == motif_occupancy_descriptor_values(
        formatted
    )


def test_motif_occupancy_tracks_cell_type_changes():
    logic_only = "NAND2_X1 u0 (.A(a), .B(b), .ZN(y));"
    control = "MUX2_X1 u0 (.A(a), .B(b), .S(s), .Z(y));"

    assert motif_occupancy_descriptor_values(logic_only) != motif_occupancy_descriptor_values(
        control
    )
